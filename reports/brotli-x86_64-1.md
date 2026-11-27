# bench-brotli

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
| Google | 1.2.0 |

## Decoding, quality 11, window 22

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 453.7 ±0.8% | 610.2 ±0.7% | 1.34 |
| silesia/mozilla | 51220480 | 27.5 | 294.0 ±0.6% | 378.6 ±0.7% | 1.29 |
| silesia/mr | 9970564 | 28.3 | 292.8 ±1.9% | 410.1 ±0.9% | 1.40 |
| silesia/nci | 33553445 | 4.8 | 1380.0 ±0.5% | 1707.2 ±2.1% | 1.24 |
| silesia/ooffice | 6152192 | 40.3 | 207.0 ±0.7% | 250.5 ±0.7% | 1.21 |
| silesia/osdb | 10085684 | 28.0 | 361.8 ±0.4% | 530.3 ±0.3% | 1.47 |
| silesia/reymont | 6627202 | 20.2 | 609.2 ±0.3% | 831.4 ±3.3% | 1.36 |
| silesia/samba | 21606400 | 17.7 | 541.7 ±0.2% | 731.1 ±2.8% | 1.35 |
| silesia/sao | 7251944 | 63.3 | 170.3 ±0.5% | 249.2 ±0.4% | 1.46 |
| silesia/webster | 41458703 | 21.2 | 536.6 ±1.1% | 758.1 ±0.6% | 1.41 |
| silesia/x-ray | 8474240 | 55.3 | 156.8 ±0.6% | 197.8 ±0.8% | 1.26 |
| silesia/xml | 5345280 | 8.1 | 1108.7 ±1.5% | 1423.8 ±0.6% | 1.28 |
| canterbury/alice29.txt | 152089 | 30.6 | 331.5 ±7.4% | 428.8 ±0.6% | 1.29 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 279.4 ±0.3% | 368.6 ±0.2% | 1.32 |
| canterbury/cp.html | 24603 | 28.0 | 387.9 ±1.5% | 506.5 ±0.9% | 1.31 |
| canterbury/fields.c | 11150 | 24.4 | 410.5 ±0.3% | 540.5 ±1.7% | 1.32 |
| canterbury/grammar.lsp | 3721 | 30.2 | 277.2 ±0.4% | 348.4 ±1.0% | 1.26 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 571.9 ±0.4% | 681.1 ±0.2% | 1.19 |
| canterbury/lcet10.txt | 426754 | 26.6 | 373.8 ±0.5% | 504.4 ±2.0% | 1.35 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 324.3 ±0.3% | 414.0 ±1.6% | 1.28 |
| canterbury/ptt5 | 513216 | 8.0 | 654.0 ±0.3% | 1112.9 ±3.5% | 1.70 |
| canterbury/sum | 38240 | 26.5 | 291.4 ±1.3% | 385.8 ±1.3% | 1.32 |
| canterbury/xargs.1 | 4227 | 34.6 | 250.1 ±6.8% | 297.1 ±0.3% | 1.19 |
| canterbury-large/E.coli | 4638690 | 24.5 | 341.2 ±0.4% | 426.0 ±0.5% | 1.25 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 576.9 ±4.4% | 773.0 ±0.2% | 1.34 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 520.5 ±5.7% | 676.8 ±0.2% | 1.30 |
| http/html-1kx1024 | 1048576 | 30.3 | 145.2 ±0.4% | 162.9 ±0.6% | 1.12 |
| http/html-16kx64 | 1048576 | 16.8 | 390.3 ±0.5% | 494.6 ±0.4% | 1.27 |
| http/html-1m | 1048576 | 13.0 | 697.1 ±0.4% | 919.1 ±0.4% | 1.32 |
| http/json-1kx1024 | 1048576 | 18.2 | 185.1 ±0.5% | 191.2 ±0.5% | 1.03 |
| http/json-16kx64 | 1048576 | 8.9 | 612.4 ±0.2% | 745.6 ±5.9% | 1.22 |
| http/json-1m | 1048576 | 7.7 | 817.3 ±0.2% | 1030.7 ±1.1% | 1.26 |
| http/js-1kx1024 | 1048576 | 35.1 | 132.1 ±0.9% | 152.2 ±0.7% | 1.15 |
| http/js-16kx64 | 1048576 | 20.7 | 333.7 ±15.8% | 421.4 ±0.2% | 1.26 |
| http/js-1m | 1048576 | 14.0 | 654.1 ±1.0% | 829.0 ±0.2% | 1.27 |
| http/css-1kx1024 | 1048576 | 22.5 | 170.2 ±0.2% | 179.8 ±0.8% | 1.06 |
| http/css-16kx64 | 1048576 | 11.7 | 540.5 ±0.5% | 661.4 ±0.3% | 1.22 |
| http/css-1m | 1048576 | 2.4 | 1163.0 ±0.5% | 3897.2 ±0.9% | 3.35 |
| shuffled/dickens-1m | 1048576 | 56.8 | 257.6 ±0.3% | 325.9 ±0.4% | 1.26 |

## stdx's fast path against its checked path

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 115.3 ±9.1% | 620.9 ±0.3% | 5.38 |
| silesia/mozilla | 51220480 | 27.5 | 102.3 ±0.7% | 376.5 ±1.0% | 3.68 |
| silesia/mr | 9970564 | 28.3 | 106.5 ±3.8% | 391.4 ±4.5% | 3.68 |
| silesia/nci | 33553445 | 4.8 | 222.4 ±0.4% | 1709.2 ±2.2% | 7.69 |
| silesia/ooffice | 6152192 | 40.3 | 75.5 ±0.8% | 248.4 ±0.7% | 3.29 |
| silesia/osdb | 10085684 | 28.0 | 124.3 ±1.9% | 526.9 ±0.5% | 4.24 |
| silesia/reymont | 6627202 | 20.2 | 107.3 ±3.5% | 826.8 ±0.8% | 7.71 |
| silesia/samba | 21606400 | 17.7 | 147.4 ±6.4% | 723.2 ±0.5% | 4.91 |
| silesia/sao | 7251944 | 63.3 | 73.8 ±0.6% | 248.3 ±4.8% | 3.36 |
| silesia/webster | 41458703 | 21.2 | 133.0 ±1.4% | 748.7 ±0.4% | 5.63 |
| silesia/x-ray | 8474240 | 55.3 | 66.8 ±2.0% | 192.0 ±0.7% | 2.87 |
| silesia/xml | 5345280 | 8.1 | 200.7 ±0.3% | 1420.2 ±0.5% | 7.08 |
| canterbury/alice29.txt | 152089 | 30.6 | 97.9 ±1.0% | 425.3 ±0.9% | 4.34 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 88.9 ±17.5% | 366.3 ±0.7% | 4.12 |
| canterbury/cp.html | 24603 | 28.0 | 100.1 ±1.2% | 502.1 ±1.6% | 5.01 |
| canterbury/fields.c | 11150 | 24.4 | 109.0 ±2.5% | 541.4 ±0.2% | 4.97 |
| canterbury/grammar.lsp | 3721 | 30.2 | 98.9 ±0.2% | 367.2 ±0.4% | 3.71 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 122.7 ±1.0% | 675.9 ±0.9% | 5.51 |
| canterbury/lcet10.txt | 426754 | 26.6 | 109.8 ±2.0% | 503.4 ±1.0% | 4.58 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 95.6 ±0.5% | 414.2 ±0.2% | 4.33 |
| canterbury/ptt5 | 513216 | 8.0 | 183.4 ±1.0% | 1110.3 ±2.8% | 6.05 |
| canterbury/sum | 38240 | 26.5 | 86.5 ±0.5% | 388.3 ±2.2% | 4.49 |
| canterbury/xargs.1 | 4227 | 34.6 | 89.6 ±0.3% | 308.1 ±0.3% | 3.44 |
| canterbury-large/E.coli | 4638690 | 24.5 | 89.6 ±6.0% | 425.8 ±0.3% | 4.75 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 130.9 ±0.8% | 765.6 ±0.7% | 5.85 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 136.6 ±1.3% | 668.9 ±0.8% | 4.90 |
| http/html-1kx1024 | 1048576 | 30.3 | 71.1 ±3.9% | 163.6 ±19.5% | 2.30 |
| http/html-16kx64 | 1048576 | 16.8 | 124.0 ±0.5% | 488.0 ±0.3% | 3.93 |
| http/html-1m | 1048576 | 13.0 | 160.0 ±0.3% | 917.2 ±1.1% | 5.73 |
| http/json-1kx1024 | 1048576 | 18.2 | 85.9 ±0.6% | 192.7 ±0.7% | 2.24 |
| http/json-16kx64 | 1048576 | 8.9 | 152.8 ±6.0% | 745.5 ±0.3% | 4.88 |
| http/json-1m | 1048576 | 7.7 | 166.0 ±0.6% | 1041.4 ±0.6% | 6.27 |
| http/js-1kx1024 | 1048576 | 35.1 | 65.4 ±4.8% | 152.2 ±0.6% | 2.33 |
| http/js-16kx64 | 1048576 | 20.7 | 109.8 ±0.6% | 422.4 ±0.2% | 3.85 |
| http/js-1m | 1048576 | 14.0 | 151.5 ±1.3% | 831.4 ±1.4% | 5.49 |
| http/css-1kx1024 | 1048576 | 22.5 | 79.6 ±1.3% | 180.0 ±0.3% | 2.26 |
| http/css-16kx64 | 1048576 | 11.7 | 143.4 ±0.4% | 655.5 ±1.4% | 4.57 |
| http/css-1m | 1048576 | 2.4 | 260.6 ±0.4% | 3879.7 ±0.8% | 14.89 |
| shuffled/dickens-1m | 1048576 | 56.8 | 78.3 ±0.7% | 326.1 ±0.2% | 4.17 |

## The claims, each off against the fast path with all on

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | S1 word refill off | S4 chunk copies off | S5 window once off | unchecked loop off |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 609.8 ±0.6% | 0.59 ±1.0% | 0.50 ±0.2% | 0.97 ±0.8% | 0.60 ±1.2% |
| silesia/mozilla | 51220480 | 27.5 | 377.7 ±0.7% | 0.68 ±2.0% | 0.64 ±1.0% | 0.98 ±1.1% | 0.72 ±1.1% |
| silesia/mr | 9970564 | 28.3 | 408.7 ±1.2% | 0.70 ±0.7% | 0.63 ±0.9% | 0.97 ±7.3% | 0.73 ±0.8% |
| silesia/nci | 33553445 | 4.8 | 1710.5 ±2.0% | 0.69 ±0.7% | 0.55 ±2.0% | 0.91 ±0.6% | 0.67 ±0.2% |
| silesia/ooffice | 6152192 | 40.3 | 247.0 ±1.0% | 0.68 ±1.3% | 0.63 ±1.4% | 0.99 ±0.5% | 0.71 ±0.5% |
| silesia/osdb | 10085684 | 28.0 | 530.3 ±0.7% | 0.70 ±1.2% | 0.66 ±1.7% | 0.91 ±0.3% | 0.73 ±0.8% |
| silesia/reymont | 6627202 | 20.2 | 838.8 ±0.6% | 0.58 ±0.7% | 0.46 ±4.7% | 0.95 ±9.4% | 0.61 ±1.4% |
| silesia/samba | 21606400 | 17.7 | 730.6 ±1.5% | 0.67 ±0.7% | 0.57 ±0.5% | 0.95 ±0.3% | 0.71 ±0.5% |
| silesia/sao | 7251944 | 63.3 | 246.5 ±3.0% | 0.70 ±3.0% | 0.70 ±11.9% | 0.98 ±1.6% | 0.72 ±3.6% |
| silesia/webster | 41458703 | 21.2 | 762.7 ±1.9% | 0.58 ±0.7% | 0.48 ±0.7% | 0.96 ±0.7% | 0.61 ±2.4% |
| silesia/x-ray | 8474240 | 55.3 | 198.0 ±0.4% | 0.70 ±9.3% | 0.74 ±1.2% | 0.98 ±0.7% | 0.73 ±1.1% |
| silesia/xml | 5345280 | 8.1 | 1425.7 ±0.5% | 0.65 ±0.5% | 0.52 ±0.5% | 0.94 ±7.4% | 0.68 ±1.4% |
| canterbury/alice29.txt | 152089 | 30.6 | 426.6 ±5.3% | 0.63 ±5.5% | 0.54 ±4.0% | 0.98 ±10.6% | 0.66 ±3.6% |
| canterbury/asyoulik.txt | 125179 | 34.1 | 366.2 ±1.1% | 0.65 ±0.9% | 0.57 ±0.6% | 0.99 ±0.3% | 0.67 ±1.6% |
| canterbury/cp.html | 24603 | 28.0 | 497.4 ±0.8% | 0.70 ±1.9% | 0.68 ±2.3% | 0.99 ±0.8% | 0.66 ±14.9% |
| canterbury/fields.c | 11150 | 24.4 | 534.8 ±6.9% | 0.70 ±1.1% | 0.66 ±0.4% | 1.01 ±0.3% | 0.65 ±0.6% |
| canterbury/grammar.lsp | 3721 | 30.2 | 371.7 ±0.8% | 0.75 ±10.0% | 0.72 ±0.7% | 0.98 ±0.6% | 0.70 ±1.2% |
| canterbury/kennedy.xls | 1029744 | 6.0 | 664.3 ±0.7% | 0.60 ±2.4% | 0.55 ±2.3% | 1.00 ±2.4% | 0.58 ±4.9% |
| canterbury/lcet10.txt | 426754 | 26.6 | 505.1 ±0.6% | 0.64 ±0.6% | 0.54 ±0.7% | 0.97 ±0.9% | 0.66 ±1.6% |
| canterbury/plrabn12.txt | 481861 | 33.9 | 417.9 ±1.8% | 0.63 ±1.2% | 0.55 ±0.2% | 0.98 ±0.6% | 0.65 ±0.6% |
| canterbury/ptt5 | 513216 | 8.0 | 1104.5 ±0.4% | 0.68 ±5.2% | 0.48 ±2.8% | 0.95 ±0.9% | 0.72 ±0.6% |
| canterbury/sum | 38240 | 26.5 | 384.8 ±1.6% | 0.60 ±1.0% | 0.57 ±1.5% | 1.00 ±1.8% | 0.62 ±1.2% |
| canterbury/xargs.1 | 4227 | 34.6 | 311.2 ±0.3% | 0.77 ±1.1% | 0.75 ±0.8% | 0.99 ±3.0% | 0.70 ±1.2% |
| canterbury-large/E.coli | 4638690 | 24.5 | 425.3 ±0.4% | 0.84 ±0.8% | 0.85 ±0.1% | 0.98 ±0.2% | 0.97 ±6.3% |
| canterbury-large/bible.txt | 4047392 | 22.0 | 765.7 ±1.3% | 0.56 ±1.5% | 0.45 ±13.5% | 0.97 ±1.0% | 0.61 ±0.6% |
| canterbury-large/world192.txt | 2473400 | 19.2 | 671.6 ±1.3% | 0.64 ±1.1% | 0.54 ±0.7% | 0.95 ±1.2% | 0.68 ±1.6% |
| http/html-1kx1024 | 1048576 | 30.3 | 163.0 ±1.2% | 0.82 ±2.2% | 0.80 ±12.9% | 0.98 ±2.5% | 0.81 ±0.4% |
| http/html-16kx64 | 1048576 | 16.8 | 495.7 ±0.7% | 0.72 ±0.8% | 0.63 ±20.2% | 0.98 ±0.9% | 0.73 ±0.3% |
| http/html-1m | 1048576 | 13.0 | 919.0 ±0.3% | 0.62 ±1.9% | 0.51 ±0.7% | 0.96 ±4.1% | 0.62 ±0.7% |
| http/json-1kx1024 | 1048576 | 18.2 | 192.6 ±0.7% | 0.85 ±0.4% | 0.84 ±1.7% | 0.98 ±0.6% | 0.83 ±0.6% |
| http/json-16kx64 | 1048576 | 8.9 | 745.6 ±0.4% | 0.67 ±0.9% | 0.62 ±0.2% | 0.97 ±0.3% | 0.68 ±0.4% |
| http/json-1m | 1048576 | 7.7 | 1040.3 ±2.3% | 0.62 ±1.6% | 0.55 ±1.5% | 0.96 ±0.7% | 0.62 ±0.6% |
| http/js-1kx1024 | 1048576 | 35.1 | 150.9 ±23.8% | 0.81 ±1.0% | 0.78 ±0.4% | 0.99 ±0.9% | 0.80 ±0.5% |
| http/js-16kx64 | 1048576 | 20.7 | 420.4 ±3.6% | 0.70 ±8.8% | 0.61 ±3.3% | 0.98 ±0.5% | 0.72 ±0.4% |
| http/js-1m | 1048576 | 14.0 | 832.7 ±0.9% | 0.62 ±2.1% | 0.51 ±9.0% | 0.96 ±1.2% | 0.66 ±0.5% |
| http/css-1kx1024 | 1048576 | 22.5 | 179.6 ±1.2% | 0.84 ±1.9% | 0.79 ±0.7% | 0.92 ±0.3% | 0.81 ±0.3% |
| http/css-16kx64 | 1048576 | 11.7 | 660.4 ±0.6% | 0.68 ±0.4% | 0.58 ±0.4% | 0.98 ±2.0% | 0.70 ±1.4% |
| http/css-1m | 1048576 | 2.4 | 3878.6 ±0.7% | 0.65 ±0.8% | 0.39 ±0.5% | 0.87 ±1.7% | 0.62 ±1.2% |
| shuffled/dickens-1m | 1048576 | 56.8 | 324.8 ±1.3% | 0.81 ±1.2% | 0.84 ±1.5% | 0.98 ±2.5% | 0.84 ±1.2% |

## Encoding speed, level 1 at WBITS 18

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Google q1, MB/s | stdx 1, MB/s | stdx 1 checked, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 164.2 ± 4.0% | 127.7 ± 7.3% | 128.9 ± 0.8% | 0.78 |
| silesia/mozilla | 51220480 | 247.1 ± 2.2% | 209.4 ± 6.9% | 209.2 ± 2.7% | 0.85 |
| silesia/mr | 9970564 | 243.6 ± 0.9% | 189.4 ± 1.1% | 191.2 ± 1.4% | 0.78 |
| silesia/nci | 33553445 | 568.3 ± 7.7% | 392.8 ± 1.8% | 388.4 ± 8.0% | 0.69 |
| silesia/ooffice | 6152192 | 195.4 ± 0.8% | 162.1 ± 0.7% | 161.6 ± 0.8% | 0.83 |
| silesia/osdb | 10085684 | 264.3 ± 2.4% | 231.1 ± 0.9% | 226.9 ± 0.9% | 0.87 |
| silesia/reymont | 6627202 | 194.7 ± 0.9% | 168.3 ± 1.0% | 168.6 ± 0.3% | 0.86 |
| silesia/samba | 21606400 | 315.5 ± 0.4% | 248.6 ± 0.6% | 247.7 ± 4.4% | 0.79 |
| silesia/sao | 7251944 | 174.4 ± 0.9% | 152.7 ± 0.5% | 152.7 ± 0.3% | 0.88 |
| silesia/webster | 41458703 | 206.7 ± 2.9% | 159.5 ± 2.1% | 159.9 ± 0.5% | 0.77 |
| silesia/x-ray | 8474240 | 279.3 ± 0.7% | 209.5 ± 1.2% | 209.3 ± 1.2% | 0.75 |
| silesia/xml | 5345280 | 428.6 ± 1.2% | 321.9 ± 1.1% | 326.9 ± 6.2% | 0.75 |
| canterbury/alice29.txt | 152089 | 178.8 ± 0.9% | 135.3 ± 0.4% | 135.8 ± 0.7% | 0.76 |
| canterbury/asyoulik.txt | 125179 | 173.0 ± 1.3% | 123.9 ± 1.1% | 124.7 ± 0.7% | 0.72 |
| canterbury/cp.html | 24603 | 284.0 ± 1.3% | 206.6 ± 2.9% | 213.8 ± 10.4% | 0.73 |
| canterbury/fields.c | 11150 | 267.8 ± 1.4% | 291.0 ± 0.6% | 290.9 ± 3.0% | 1.09 |
| canterbury/grammar.lsp | 3721 | 212.3 ± 0.6% | 202.8 ± 1.3% | 203.9 ± 0.8% | 0.96 |
| canterbury/kennedy.xls | 1029744 | 293.8 ± 1.7% | 317.4 ± 1.2% | 318.6 ± 1.9% | 1.08 |
| canterbury/lcet10.txt | 426754 | 183.7 ± 1.1% | 147.0 ± 1.1% | 147.6 ± 0.8% | 0.80 |
| canterbury/plrabn12.txt | 481861 | 154.9 ± 0.7% | 120.9 ± 1.1% | 121.0 ± 0.7% | 0.78 |
| canterbury/ptt5 | 513216 | 617.1 ± 0.3% | 374.3 ± 1.8% | 369.1 ± 0.8% | 0.61 |
| canterbury/sum | 38240 | 278.4 ± 0.6% | 165.7 ± 0.5% | 165.9 ± 0.4% | 0.60 |
| canterbury/xargs.1 | 4227 | 193.0 ± 0.9% | 189.3 ± 7.1% | 192.2 ± 1.1% | 0.98 |
| canterbury-large/E.coli | 4638690 | 221.3 ± 0.5% | 447.3 ± 2.1% | 441.0 ± 0.6% | 2.02 |
| canterbury-large/bible.txt | 4047392 | 201.8 ± 0.8% | 159.1 ± 0.7% | 158.1 ± 7.1% | 0.79 |
| canterbury-large/world192.txt | 2473400 | 223.9 ± 1.3% | 180.4 ± 0.7% | 179.6 ± 3.0% | 0.81 |
| http/html-1kx1024 | 1048576 | 82.8 ± 0.5% | 92.8 ± 0.5% | 92.9 ± 1.9% | 1.12 |
| http/html-16kx64 | 1048576 | 255.9 ± 2.1% | 211.7 ± 11.1% | 212.1 ± 1.2% | 0.83 |
| http/html-1m | 1048576 | 334.3 ± 0.7% | 246.0 ± 1.5% | 247.4 ± 1.2% | 0.74 |
| http/json-1kx1024 | 1048576 | 108.0 ± 0.7% | 121.9 ± 0.5% | 121.7 ± 0.5% | 1.13 |
| http/json-16kx64 | 1048576 | 377.9 ± 1.5% | 351.2 ± 1.0% | 351.7 ± 1.4% | 0.93 |
| http/json-1m | 1048576 | 492.3 ± 0.6% | 356.4 ± 1.2% | 356.7 ± 0.8% | 0.72 |
| http/js-1kx1024 | 1048576 | 76.5 ± 3.2% | 83.0 ± 0.7% | 83.2 ± 0.3% | 1.08 |
| http/js-16kx64 | 1048576 | 222.5 ± 0.7% | 180.8 ± 0.6% | 181.7 ± 0.6% | 0.81 |
| http/js-1m | 1048576 | 309.8 ± 7.1% | 235.7 ± 3.0% | 233.8 ± 1.0% | 0.76 |
| http/css-1kx1024 | 1048576 | 96.0 ± 1.6% | 107.1 ± 1.1% | 107.5 ± 6.1% | 1.12 |
| http/css-16kx64 | 1048576 | 319.6 ± 2.3% | 278.8 ± 2.8% | 280.1 ± 1.1% | 0.87 |
| http/css-1m | 1048576 | 500.5 ± 2.8% | 424.7 ± 2.7% | 421.3 ± 3.0% | 0.85 |
| shuffled/dickens-1m | 1048576 | 328.5 ± 0.4% | 491.0 ± 1.3% | 489.6 ± 1.4% | 1.49 |

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
| silesia/dickens | 10192446 | 30.4 ± 4.5% | 40.3 ± 0.6% | 1.33 |
| silesia/mozilla | 51220480 | 48.3 ± 0.5% | 49.1 ± 0.7% | 1.02 |
| silesia/mr | 9970564 | 38.2 ± 5.8% | 46.9 ± 3.5% | 1.23 |
| silesia/nci | 33553445 | 102.1 ± 2.2% | 103.7 ± 0.5% | 1.02 |
| silesia/ooffice | 6152192 | 35.3 ± 6.2% | 39.1 ± 1.1% | 1.11 |
| silesia/osdb | 10085684 | 47.6 ± 2.8% | 59.1 ± 2.1% | 1.24 |
| silesia/reymont | 6627202 | 37.9 ± 4.1% | 45.5 ± 6.9% | 1.20 |
| silesia/samba | 21606400 | 63.0 ± 2.7% | 68.1 ± 1.3% | 1.08 |
| silesia/sao | 7251944 | 29.5 ± 2.0% | 36.0 ± 1.1% | 1.22 |
| silesia/webster | 41458703 | 42.9 ± 2.0% | 49.9 ± 1.4% | 1.16 |
| silesia/x-ray | 8474240 | 30.6 ± 3.2% | 36.1 ± 3.6% | 1.18 |
| silesia/xml | 5345280 | 88.9 ± 1.2% | 101.4 ± 1.6% | 1.14 |
| canterbury/alice29.txt | 152089 | 34.7 ± 2.5% | 44.4 ± 1.9% | 1.28 |
| canterbury/asyoulik.txt | 125179 | 32.6 ± 1.4% | 41.1 ± 0.8% | 1.26 |
| canterbury/cp.html | 24603 | 41.6 ± 2.3% | 56.6 ± 1.2% | 1.36 |
| canterbury/fields.c | 11150 | 45.2 ± 1.7% | 67.8 ± 0.8% | 1.50 |
| canterbury/grammar.lsp | 3721 | 46.3 ± 1.3% | 67.9 ± 1.3% | 1.47 |
| canterbury/kennedy.xls | 1029744 | 64.2 ± 0.8% | 53.9 ± 0.7% | 0.84 |
| canterbury/lcet10.txt | 426754 | 36.5 ± 8.1% | 45.9 ± 2.9% | 1.26 |
| canterbury/plrabn12.txt | 481861 | 30.1 ± 1.0% | 36.8 ± 3.2% | 1.22 |
| canterbury/ptt5 | 513216 | 96.0 ± 1.8% | 97.5 ± 2.1% | 1.02 |
| canterbury/sum | 38240 | 41.3 ± 2.3% | 48.7 ± 2.0% | 1.18 |
| canterbury/xargs.1 | 4227 | 40.5 ± 5.9% | 63.7 ± 0.5% | 1.57 |
| canterbury-large/E.coli | 4638690 | 28.8 ± 1.7% | 89.9 ± 0.6% | 3.12 |
| canterbury-large/bible.txt | 4047392 | 37.7 ± 6.6% | 47.5 ± 1.7% | 1.26 |
| canterbury-large/world192.txt | 2473400 | 46.2 ± 2.0% | 58.3 ± 5.0% | 1.26 |
| http/html-1kx1024 | 1048576 | 24.0 ± 1.9% | 40.3 ± 1.0% | 1.68 |
| http/html-16kx64 | 1048576 | 53.4 ± 3.7% | 70.3 ± 1.9% | 1.32 |
| http/html-1m | 1048576 | 62.1 ± 4.7% | 78.2 ± 1.7% | 1.26 |
| http/json-1kx1024 | 1048576 | 33.6 ± 1.0% | 54.3 ± 4.2% | 1.62 |
| http/json-16kx64 | 1048576 | 74.8 ± 1.9% | 81.7 ± 1.8% | 1.09 |
| http/json-1m | 1048576 | 75.3 ± 2.3% | 76.1 ± 0.9% | 1.01 |
| http/js-1kx1024 | 1048576 | 21.6 ± 19.2% | 35.8 ± 4.3% | 1.66 |
| http/js-16kx64 | 1048576 | 45.7 ± 1.6% | 60.9 ± 1.1% | 1.33 |
| http/js-1m | 1048576 | 56.4 ± 1.5% | 72.8 ± 0.9% | 1.29 |
| http/css-1kx1024 | 1048576 | 30.3 ± 1.7% | 50.1 ± 2.1% | 1.65 |
| http/css-16kx64 | 1048576 | 69.9 ± 6.3% | 87.6 ± 1.4% | 1.25 |
| http/css-1m | 1048576 | 216.6 ± 12.5% | 215.3 ± 11.6% | 0.99 |
| shuffled/dickens-1m | 1048576 | 34.2 ± 0.8% | 76.7 ± 1.1% | 2.24 |

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
| silesia/dickens | 10192446 | 1 | 22 | 149.3 ± 0.7% | 2.522 |
| silesia/mozilla | 51220480 | 1 | 22 | 223.2 ± 2.3% | 2.516 |
| silesia/mr | 9970564 | 1 | 22 | 216.9 ± 1.2% | 2.658 |
| silesia/nci | 33553445 | 1 | 22 | 553.0 ± 3.0% | 9.472 |
| silesia/ooffice | 6152192 | 1 | 22 | 176.2 ± 0.5% | 1.770 |
| silesia/osdb | 10085684 | 1 | 22 | 246.8 ± 1.0% | 2.731 |
| silesia/reymont | 6627202 | 1 | 22 | 194.5 ± 1.2% | 3.052 |
| silesia/samba | 21606400 | 1 | 22 | 300.8 ± 0.4% | 3.880 |
| silesia/sao | 7251944 | 1 | 22 | 152.8 ± 2.6% | 1.226 |
| silesia/webster | 41458703 | 1 | 22 | 183.4 ± 1.3% | 3.080 |
| silesia/x-ray | 8474240 | 1 | 22 | 219.2 ± 2.5% | 1.267 |
| silesia/xml | 5345280 | 1 | 22 | 438.8 ± 0.4% | 6.994 |
| canterbury/alice29.txt | 152089 | 1 | 22 | 178.9 ± 2.3% | 2.523 |
| canterbury/asyoulik.txt | 125179 | 1 | 22 | 173.0 ± 1.4% | 2.344 |
| canterbury/cp.html | 24603 | 1 | 22 | 285.1 ± 2.0% | 2.682 |
| canterbury/fields.c | 11150 | 1 | 22 | 267.8 ± 1.0% | 2.965 |
| canterbury/grammar.lsp | 3721 | 1 | 22 | 214.6 ± 1.5% | 2.665 |
| canterbury/kennedy.xls | 1029744 | 1 | 22 | 290.3 ± 0.8% | 6.009 |
| canterbury/lcet10.txt | 426754 | 1 | 22 | 181.5 ± 8.2% | 2.755 |
| canterbury/plrabn12.txt | 481861 | 1 | 22 | 149.8 ± 1.2% | 2.338 |
| canterbury/ptt5 | 513216 | 1 | 22 | 616.9 ± 0.3% | 8.698 |
| canterbury/sum | 38240 | 1 | 22 | 278.7 ± 6.2% | 2.673 |
| canterbury/xargs.1 | 4227 | 1 | 22 | 193.6 ± 0.5% | 2.178 |
| canterbury-large/E.coli | 4638690 | 1 | 22 | 226.2 ± 0.5% | 3.283 |
| canterbury-large/bible.txt | 4047392 | 1 | 22 | 193.8 ± 0.8% | 3.128 |
| canterbury-large/world192.txt | 2473400 | 1 | 22 | 205.5 ± 0.6% | 3.264 |
| http/html-1kx1024 | 1048576 | 1 | 22 | 82.7 ± 0.3% | 2.436 |
| http/html-16kx64 | 1048576 | 1 | 22 | 256.2 ± 0.6% | 4.129 |
| http/html-1m | 1048576 | 1 | 22 | 323.9 ± 0.5% | 5.112 |
| http/json-1kx1024 | 1048576 | 1 | 22 | 108.0 ± 0.3% | 4.117 |
| http/json-16kx64 | 1048576 | 1 | 22 | 377.8 ± 0.6% | 6.727 |
| http/json-1m | 1048576 | 1 | 22 | 493.7 ± 0.4% | 7.629 |
| http/js-1kx1024 | 1048576 | 1 | 22 | 76.4 ± 0.5% | 2.143 |
| http/js-16kx64 | 1048576 | 1 | 22 | 222.6 ± 1.0% | 3.416 |
| http/js-1m | 1048576 | 1 | 22 | 304.1 ± 1.3% | 4.651 |
| http/css-1kx1024 | 1048576 | 1 | 22 | 96.1 ± 1.3% | 3.229 |
| http/css-16kx64 | 1048576 | 1 | 22 | 325.1 ± 0.8% | 5.368 |
| http/css-1m | 1048576 | 1 | 22 | 624.0 ± 0.5% | 9.626 |
| shuffled/dickens-1m | 1048576 | 1 | 22 | 325.8 ± 0.6% | 1.760 |

## stdx built ReleaseFast against Google's brotli, quality 11, window 22 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 456.6 ±1.3% | 612.3 ±0.8% | 1.34 |
| silesia/mozilla | 51220480 | 27.5 | 294.8 ±0.3% | 378.6 ±0.3% | 1.28 |
| silesia/mr | 9970564 | 28.3 | 297.1 ±1.7% | 405.5 ±0.9% | 1.36 |
| silesia/nci | 33553445 | 4.8 | 1380.2 ±4.5% | 1745.0 ±0.9% | 1.26 |
| silesia/ooffice | 6152192 | 40.3 | 206.2 ±0.2% | 248.5 ±0.6% | 1.21 |
| silesia/osdb | 10085684 | 28.0 | 363.9 ±0.5% | 525.7 ±0.9% | 1.44 |
| silesia/reymont | 6627202 | 20.2 | 611.7 ±0.4% | 820.1 ±0.4% | 1.34 |
| silesia/samba | 21606400 | 17.7 | 544.0 ±0.9% | 726.1 ±2.2% | 1.33 |
| silesia/sao | 7251944 | 63.3 | 171.7 ±0.8% | 243.1 ±0.4% | 1.42 |
| silesia/webster | 41458703 | 21.2 | 534.3 ±1.3% | 755.2 ±1.1% | 1.41 |
| silesia/x-ray | 8474240 | 55.3 | 157.3 ±0.4% | 193.3 ±0.6% | 1.23 |
| silesia/xml | 5345280 | 8.1 | 1104.6 ±1.5% | 1432.8 ±0.9% | 1.30 |
| canterbury/alice29.txt | 152089 | 30.6 | 328.1 ±0.4% | 429.9 ±0.5% | 1.31 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 277.9 ±1.4% | 369.2 ±0.7% | 1.33 |
| canterbury/cp.html | 24603 | 28.0 | 387.2 ±0.5% | 504.2 ±1.1% | 1.30 |
| canterbury/fields.c | 11150 | 24.4 | 435.2 ±0.2% | 547.6 ±0.4% | 1.26 |
| canterbury/grammar.lsp | 3721 | 30.2 | 297.0 ±1.8% | 384.4 ±0.1% | 1.29 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 571.6 ±0.6% | 666.0 ±1.3% | 1.17 |
| canterbury/lcet10.txt | 426754 | 26.6 | 370.5 ±0.5% | 505.8 ±0.2% | 1.36 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 321.9 ±0.9% | 421.6 ±0.2% | 1.31 |
| canterbury/ptt5 | 513216 | 8.0 | 652.9 ±0.3% | 1118.5 ±0.2% | 1.71 |
| canterbury/sum | 38240 | 26.5 | 289.2 ±0.7% | 379.8 ±0.3% | 1.31 |
| canterbury/xargs.1 | 4227 | 34.6 | 268.5 ±0.2% | 318.4 ±1.0% | 1.19 |
| canterbury-large/E.coli | 4638690 | 24.5 | 348.2 ±0.3% | 425.3 ±0.1% | 1.22 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 579.1 ±0.5% | 767.3 ±6.4% | 1.32 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 520.9 ±1.9% | 677.6 ±0.8% | 1.30 |
| http/html-1kx1024 | 1048576 | 30.3 | 148.6 ±5.3% | 167.8 ±3.4% | 1.13 |
| http/html-16kx64 | 1048576 | 16.8 | 395.9 ±0.4% | 483.3 ±2.3% | 1.22 |
| http/html-1m | 1048576 | 13.0 | 690.6 ±2.3% | 920.8 ±9.6% | 1.33 |
| http/json-1kx1024 | 1048576 | 18.2 | 188.3 ±0.2% | 199.7 ±6.6% | 1.06 |
| http/json-16kx64 | 1048576 | 8.9 | 627.2 ±3.8% | 749.0 ±5.5% | 1.19 |
| http/json-1m | 1048576 | 7.7 | 815.5 ±0.1% | 1016.6 ±0.4% | 1.25 |
| http/js-1kx1024 | 1048576 | 35.1 | 134.3 ±8.9% | 155.6 ±0.4% | 1.16 |
| http/js-16kx64 | 1048576 | 20.7 | 344.0 ±0.4% | 419.0 ±0.7% | 1.22 |
| http/js-1m | 1048576 | 14.0 | 652.3 ±2.5% | 831.9 ±2.7% | 1.28 |
| http/css-1kx1024 | 1048576 | 22.5 | 174.2 ±6.3% | 187.4 ±0.3% | 1.08 |
| http/css-16kx64 | 1048576 | 11.7 | 554.4 ±0.2% | 660.0 ±0.9% | 1.19 |
| http/css-1m | 1048576 | 2.4 | 1281.6 ±0.6% | 3905.4 ±1.9% | 3.05 |
| shuffled/dickens-1m | 1048576 | 56.8 | 254.9 ±0.1% | 326.2 ±0.2% | 1.28 |
