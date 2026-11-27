# bench-brotli

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261122.195.1 |
| CPU model | Neoverse-N2 |
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
| silesia/dickens | 10192446 | 28.0 | 444.6 ±0.7% | 585.6 ±0.8% | 1.32 |
| silesia/mozilla | 51220480 | 27.5 | 355.6 ±0.3% | 459.1 ±1.5% | 1.29 |
| silesia/mr | 9970564 | 28.3 | 320.0 ±0.6% | 439.2 ±1.0% | 1.37 |
| silesia/nci | 33553445 | 4.8 | 1606.3 ±0.3% | 2006.1 ±2.4% | 1.25 |
| silesia/ooffice | 6152192 | 40.3 | 246.4 ±1.1% | 300.1 ±1.0% | 1.22 |
| silesia/osdb | 10085684 | 28.0 | 386.4 ±1.1% | 566.1 ±1.5% | 1.46 |
| silesia/reymont | 6627202 | 20.2 | 606.4 ±0.6% | 814.3 ±0.7% | 1.34 |
| silesia/samba | 21606400 | 17.7 | 637.5 ±0.2% | 879.1 ±0.7% | 1.38 |
| silesia/sao | 7251944 | 63.3 | 194.2 ±0.3% | 295.6 ±1.1% | 1.52 |
| silesia/webster | 41458703 | 21.2 | 547.8 ±0.5% | 706.5 ±1.3% | 1.29 |
| silesia/x-ray | 8474240 | 55.3 | 166.6 ±1.1% | 202.2 ±0.5% | 1.21 |
| silesia/xml | 5345280 | 8.1 | 1308.8 ±0.3% | 1898.7 ±0.7% | 1.45 |
| canterbury/alice29.txt | 152089 | 30.6 | 383.6 ±0.4% | 563.8 ±1.1% | 1.47 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 328.4 ±0.2% | 483.3 ±1.2% | 1.47 |
| canterbury/cp.html | 24603 | 28.0 | 377.1 ±0.9% | 581.2 ±3.5% | 1.54 |
| canterbury/fields.c | 11150 | 24.4 | 491.1 ±2.2% | 696.8 ±0.2% | 1.42 |
| canterbury/grammar.lsp | 3721 | 30.2 | 348.7 ±0.2% | 472.3 ±0.1% | 1.35 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 620.6 ±0.6% | 886.2 ±0.9% | 1.43 |
| canterbury/lcet10.txt | 426754 | 26.6 | 442.9 ±0.1% | 654.3 ±0.3% | 1.48 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 376.6 ±0.3% | 550.1 ±0.5% | 1.46 |
| canterbury/ptt5 | 513216 | 8.0 | 795.2 ±0.7% | 1436.0 ±0.3% | 1.81 |
| canterbury/sum | 38240 | 26.5 | 313.7 ±0.4% | 412.7 ±1.0% | 1.32 |
| canterbury/xargs.1 | 4227 | 34.6 | 313.6 ±0.3% | 395.4 ±0.3% | 1.26 |
| canterbury-large/E.coli | 4638690 | 24.5 | 404.1 ±0.5% | 495.2 ±0.3% | 1.23 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 602.8 ±0.5% | 848.8 ±0.7% | 1.41 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 582.7 ±0.5% | 783.3 ±0.5% | 1.34 |
| http/html-1kx1024 | 1048576 | 30.3 | 189.5 ±0.1% | 219.3 ±0.1% | 1.16 |
| http/html-16kx64 | 1048576 | 16.8 | 506.1 ±0.4% | 659.8 ±0.1% | 1.30 |
| http/html-1m | 1048576 | 13.0 | 846.0 ±0.4% | 1179.0 ±0.3% | 1.39 |
| http/json-1kx1024 | 1048576 | 18.2 | 236.1 ±0.1% | 258.0 ±0.1% | 1.09 |
| http/json-16kx64 | 1048576 | 8.9 | 772.0 ±0.0% | 1005.4 ±0.1% | 1.30 |
| http/json-1m | 1048576 | 7.7 | 1001.5 ±0.3% | 1379.0 ±0.5% | 1.38 |
| http/js-1kx1024 | 1048576 | 35.1 | 171.5 ±0.1% | 205.0 ±0.1% | 1.20 |
| http/js-16kx64 | 1048576 | 20.7 | 425.3 ±0.2% | 562.7 ±0.2% | 1.32 |
| http/js-1m | 1048576 | 14.0 | 786.3 ±0.5% | 1070.8 ±0.7% | 1.36 |
| http/css-1kx1024 | 1048576 | 22.5 | 220.6 ±0.4% | 242.5 ±0.2% | 1.10 |
| http/css-16kx64 | 1048576 | 11.7 | 689.5 ±0.1% | 886.6 ±0.1% | 1.29 |
| http/css-1m | 1048576 | 2.4 | 1398.0 ±0.5% | 4695.2 ±0.5% | 3.36 |
| shuffled/dickens-1m | 1048576 | 56.8 | 333.2 ±0.6% | 383.7 ±0.6% | 1.15 |

## stdx's fast path against its checked path

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 113.4 ±2.8% | 581.9 ±1.0% | 5.13 |
| silesia/mozilla | 51220480 | 27.5 | 110.6 ±0.9% | 459.7 ±1.5% | 4.16 |
| silesia/mr | 9970564 | 28.3 | 108.1 ±1.7% | 435.4 ±0.9% | 4.03 |
| silesia/nci | 33553445 | 4.8 | 212.8 ±0.5% | 1924.9 ±3.1% | 9.04 |
| silesia/ooffice | 6152192 | 40.3 | 82.5 ±0.9% | 299.2 ±0.2% | 3.63 |
| silesia/osdb | 10085684 | 28.0 | 121.1 ±1.1% | 559.2 ±1.7% | 4.62 |
| silesia/reymont | 6627202 | 20.2 | 135.9 ±0.4% | 813.2 ±0.3% | 5.98 |
| silesia/samba | 21606400 | 17.7 | 152.2 ±0.7% | 872.7 ±1.5% | 5.74 |
| silesia/sao | 7251944 | 63.3 | 79.2 ±0.9% | 291.8 ±1.9% | 3.69 |
| silesia/webster | 41458703 | 21.2 | 128.0 ±1.5% | 689.9 ±2.1% | 5.39 |
| silesia/x-ray | 8474240 | 55.3 | 69.3 ±0.9% | 202.4 ±0.5% | 2.92 |
| silesia/xml | 5345280 | 8.1 | 197.3 ±0.1% | 1899.8 ±0.3% | 9.63 |
| canterbury/alice29.txt | 152089 | 30.6 | 109.6 ±0.1% | 562.7 ±0.4% | 5.14 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 100.7 ±0.0% | 482.9 ±0.7% | 4.80 |
| canterbury/cp.html | 24603 | 28.0 | 113.0 ±0.1% | 602.9 ±3.4% | 5.34 |
| canterbury/fields.c | 11150 | 24.4 | 116.6 ±0.1% | 697.1 ±0.2% | 5.98 |
| canterbury/grammar.lsp | 3721 | 30.2 | 99.6 ±0.2% | 470.4 ±0.4% | 4.72 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 130.8 ±0.2% | 889.3 ±0.5% | 6.80 |
| canterbury/lcet10.txt | 426754 | 26.6 | 121.2 ±0.1% | 656.3 ±0.5% | 5.42 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 107.1 ±0.1% | 553.9 ±0.3% | 5.17 |
| canterbury/ptt5 | 513216 | 8.0 | 187.1 ±0.1% | 1447.1 ±0.2% | 7.73 |
| canterbury/sum | 38240 | 26.5 | 97.4 ±0.1% | 424.1 ±1.0% | 4.36 |
| canterbury/xargs.1 | 4227 | 34.6 | 91.5 ±0.2% | 398.1 ±0.5% | 4.35 |
| canterbury-large/E.coli | 4638690 | 24.5 | 109.4 ±0.1% | 494.5 ±0.4% | 4.52 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 135.7 ±0.6% | 858.5 ±0.6% | 6.33 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 142.7 ±0.6% | 793.3 ±0.4% | 5.56 |
| http/html-1kx1024 | 1048576 | 30.3 | 84.4 ±0.1% | 220.4 ±0.1% | 2.61 |
| http/html-16kx64 | 1048576 | 16.8 | 139.2 ±0.1% | 660.4 ±0.3% | 4.74 |
| http/html-1m | 1048576 | 13.0 | 167.1 ±0.1% | 1187.0 ±0.4% | 7.10 |
| http/json-1kx1024 | 1048576 | 18.2 | 99.1 ±0.1% | 254.1 ±0.1% | 2.56 |
| http/json-16kx64 | 1048576 | 8.9 | 161.0 ±0.2% | 1004.8 ±0.3% | 6.24 |
| http/json-1m | 1048576 | 7.7 | 175.4 ±0.1% | 1379.8 ±0.3% | 7.86 |
| http/js-1kx1024 | 1048576 | 35.1 | 78.4 ±0.1% | 205.0 ±0.2% | 2.62 |
| http/js-16kx64 | 1048576 | 20.7 | 124.8 ±0.1% | 561.6 ±0.1% | 4.50 |
| http/js-1m | 1048576 | 14.0 | 158.5 ±0.1% | 1075.1 ±0.6% | 6.78 |
| http/css-1kx1024 | 1048576 | 22.5 | 94.4 ±0.1% | 243.0 ±0.1% | 2.57 |
| http/css-16kx64 | 1048576 | 11.7 | 157.0 ±0.2% | 884.3 ±0.1% | 5.63 |
| http/css-1m | 1048576 | 2.4 | 244.9 ±0.1% | 4734.8 ±0.5% | 19.34 |
| shuffled/dickens-1m | 1048576 | 56.8 | 91.5 ±0.1% | 387.6 ±0.6% | 4.24 |

## The claims, each off against the fast path with all on

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | S1 word refill off | S4 chunk copies off | S5 window once off | unchecked loop off |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 580.5 ±1.3% | 0.55 ±2.8% | 0.52 ±1.8% | 0.98 ±6.6% | 0.52 ±7.6% |
| silesia/mozilla | 51220480 | 27.5 | 453.8 ±1.3% | 0.67 ±2.5% | 0.65 ±0.9% | 0.98 ±0.6% | 0.66 ±0.6% |
| silesia/mr | 9970564 | 28.3 | 438.7 ±1.2% | 0.64 ±1.1% | 0.62 ±0.9% | 0.98 ±1.1% | 0.62 ±2.0% |
| silesia/nci | 33553445 | 4.8 | 1968.8 ±0.7% | 0.65 ±1.7% | 0.49 ±2.0% | 0.93 ±2.1% | 0.62 ±1.3% |
| silesia/ooffice | 6152192 | 40.3 | 300.4 ±0.8% | 0.66 ±20.2% | 0.66 ±6.1% | 0.99 ±0.5% | 0.66 ±1.7% |
| silesia/osdb | 10085684 | 28.0 | 560.0 ±1.5% | 0.65 ±3.8% | 0.61 ±2.2% | 0.98 ±1.5% | 0.64 ±2.4% |
| silesia/reymont | 6627202 | 20.2 | 818.8 ±0.7% | 0.55 ±1.6% | 0.50 ±42.2% | 0.97 ±19.0% | 0.53 ±13.3% |
| silesia/samba | 21606400 | 17.7 | 875.6 ±1.8% | 0.63 ±1.2% | 0.58 ±0.5% | 0.96 ±1.3% | 0.62 ±1.2% |
| silesia/sao | 7251944 | 63.3 | 290.3 ±1.8% | 0.66 ±10.5% | 0.71 ±10.9% | 1.00 ±1.1% | 0.65 ±2.0% |
| silesia/webster | 41458703 | 21.2 | 688.9 ±1.3% | 0.56 ±2.2% | 0.53 ±1.1% | 0.98 ±1.3% | 0.55 ±1.4% |
| silesia/x-ray | 8474240 | 55.3 | 204.6 ±0.6% | 0.69 ±1.2% | 0.77 ±1.8% | 0.99 ±2.0% | 0.66 ±1.3% |
| silesia/xml | 5345280 | 8.1 | 1894.4 ±0.4% | 0.60 ±0.4% | 0.47 ±0.3% | 0.94 ±0.3% | 0.57 ±0.6% |
| canterbury/alice29.txt | 152089 | 30.6 | 563.1 ±1.2% | 0.59 ±0.2% | 0.55 ±0.1% | 0.99 ±0.6% | 0.58 ±0.1% |
| canterbury/asyoulik.txt | 125179 | 34.1 | 486.6 ±1.0% | 0.60 ±0.1% | 0.56 ±0.6% | 0.98 ±0.4% | 0.58 ±0.2% |
| canterbury/cp.html | 24603 | 28.0 | 606.1 ±1.1% | 0.59 ±0.3% | 0.57 ±0.6% | 0.97 ±3.0% | 0.56 ±0.3% |
| canterbury/fields.c | 11150 | 24.4 | 694.9 ±0.1% | 0.60 ±1.0% | 0.57 ±1.4% | 0.99 ±0.2% | 0.51 ±0.5% |
| canterbury/grammar.lsp | 3721 | 30.2 | 472.0 ±0.0% | 0.69 ±0.6% | 0.69 ±0.5% | 0.98 ±0.2% | 0.59 ±0.5% |
| canterbury/kennedy.xls | 1029744 | 6.0 | 889.2 ±0.4% | 0.58 ±0.4% | 0.53 ±0.3% | 0.97 ±0.2% | 0.51 ±0.3% |
| canterbury/lcet10.txt | 426754 | 26.6 | 655.9 ±0.6% | 0.59 ±0.2% | 0.54 ±0.3% | 0.97 ±0.2% | 0.58 ±0.2% |
| canterbury/plrabn12.txt | 481861 | 33.9 | 553.5 ±0.5% | 0.57 ±0.1% | 0.54 ±0.1% | 0.98 ±0.4% | 0.56 ±0.1% |
| canterbury/ptt5 | 513216 | 8.0 | 1449.1 ±0.5% | 0.66 ±0.2% | 0.47 ±0.1% | 0.95 ±1.0% | 0.66 ±0.2% |
| canterbury/sum | 38240 | 26.5 | 421.9 ±2.8% | 0.65 ±0.4% | 0.63 ±0.4% | 1.00 ±3.5% | 0.63 ±0.3% |
| canterbury/xargs.1 | 4227 | 34.6 | 395.4 ±0.3% | 0.71 ±0.8% | 0.71 ±0.8% | 0.98 ±0.2% | 0.62 ±0.6% |
| canterbury-large/E.coli | 4638690 | 24.5 | 494.3 ±0.2% | 0.88 ±6.2% | 0.91 ±0.4% | 0.98 ±0.2% | 0.87 ±0.4% |
| canterbury-large/bible.txt | 4047392 | 22.0 | 858.5 ±0.6% | 0.54 ±0.6% | 0.48 ±0.5% | 0.97 ±0.7% | 0.53 ±0.5% |
| canterbury-large/world192.txt | 2473400 | 19.2 | 791.3 ±0.4% | 0.61 ±0.5% | 0.56 ±0.2% | 0.97 ±0.5% | 0.60 ±0.3% |
| http/html-1kx1024 | 1048576 | 30.3 | 219.7 ±0.1% | 0.80 ±0.1% | 0.81 ±0.1% | 0.98 ±0.6% | 0.80 ±0.1% |
| http/html-16kx64 | 1048576 | 16.8 | 660.0 ±0.2% | 0.68 ±0.2% | 0.63 ±0.2% | 0.98 ±0.2% | 0.66 ±0.1% |
| http/html-1m | 1048576 | 13.0 | 1191.4 ±0.4% | 0.59 ±0.3% | 0.51 ±0.3% | 0.96 ±0.3% | 0.57 ±0.4% |
| http/json-1kx1024 | 1048576 | 18.2 | 256.8 ±0.2% | 0.85 ±0.1% | 0.83 ±0.1% | 0.98 ±0.1% | 0.83 ±0.0% |
| http/json-16kx64 | 1048576 | 8.9 | 1003.7 ±0.1% | 0.66 ±0.1% | 0.59 ±0.1% | 0.98 ±0.2% | 0.63 ±0.1% |
| http/json-1m | 1048576 | 7.7 | 1378.5 ±0.4% | 0.60 ±0.5% | 0.52 ±0.4% | 0.95 ±0.2% | 0.56 ±0.1% |
| http/js-1kx1024 | 1048576 | 35.1 | 205.7 ±0.1% | 0.78 ±0.1% | 0.79 ±0.1% | 0.98 ±0.2% | 0.78 ±0.1% |
| http/js-16kx64 | 1048576 | 20.7 | 562.8 ±0.2% | 0.67 ±0.1% | 0.62 ±0.2% | 0.98 ±0.2% | 0.65 ±0.1% |
| http/js-1m | 1048576 | 14.0 | 1077.3 ±0.4% | 0.59 ±0.5% | 0.51 ±0.3% | 0.96 ±0.3% | 0.57 ±0.5% |
| http/css-1kx1024 | 1048576 | 22.5 | 243.5 ±0.1% | 0.82 ±0.1% | 0.81 ±0.2% | 0.98 ±0.1% | 0.81 ±0.2% |
| http/css-16kx64 | 1048576 | 11.7 | 885.2 ±0.2% | 0.65 ±0.2% | 0.57 ±0.2% | 0.98 ±0.2% | 0.64 ±0.1% |
| http/css-1m | 1048576 | 2.4 | 4628.2 ±1.5% | 0.64 ±0.6% | 0.35 ±0.4% | 0.87 ±0.4% | 0.58 ±0.3% |
| shuffled/dickens-1m | 1048576 | 56.8 | 386.7 ±0.2% | 0.88 ±0.4% | 0.94 ±0.2% | 0.99 ±0.4% | 0.87 ±0.2% |

## Encoding speed, level 1 at WBITS 18

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Google q1, MB/s | stdx 1, MB/s | stdx 1 checked, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 197.4 ± 0.5% | 172.9 ± 0.4% | 173.0 ± 0.4% | 0.88 |
| silesia/mozilla | 51220480 | 265.1 ± 0.4% | 273.2 ± 0.1% | 273.2 ± 0.2% | 1.03 |
| silesia/mr | 9970564 | 266.7 ± 0.3% | 246.0 ± 0.8% | 244.5 ± 0.6% | 0.92 |
| silesia/nci | 33553445 | 656.6 ± 0.9% | 554.9 ± 0.3% | 554.6 ± 0.5% | 0.85 |
| silesia/ooffice | 6152192 | 202.2 ± 1.4% | 200.1 ± 1.5% | 199.8 ± 0.9% | 0.99 |
| silesia/osdb | 10085684 | 284.8 ± 0.6% | 287.7 ± 0.5% | 288.2 ± 0.4% | 1.01 |
| silesia/reymont | 6627202 | 234.0 ± 0.5% | 233.2 ± 0.2% | 233.2 ± 0.3% | 1.00 |
| silesia/samba | 21606400 | 355.5 ± 0.5% | 339.5 ± 0.2% | 339.0 ± 0.4% | 0.96 |
| silesia/sao | 7251944 | 171.8 ± 0.3% | 179.5 ± 0.5% | 179.6 ± 0.2% | 1.04 |
| silesia/webster | 41458703 | 244.6 ± 0.5% | 220.4 ± 1.4% | 220.4 ± 1.4% | 0.90 |
| silesia/x-ray | 8474240 | 243.9 ± 1.0% | 256.6 ± 0.4% | 256.3 ± 0.3% | 1.05 |
| silesia/xml | 5345280 | 500.1 ± 0.7% | 459.6 ± 0.7% | 456.8 ± 1.2% | 0.92 |
| canterbury/alice29.txt | 152089 | 210.1 ± 0.3% | 184.6 ± 0.2% | 184.7 ± 0.0% | 0.88 |
| canterbury/asyoulik.txt | 125179 | 201.1 ± 0.8% | 168.6 ± 0.1% | 168.7 ± 0.1% | 0.84 |
| canterbury/cp.html | 24603 | 265.3 ± 1.2% | 234.9 ± 0.3% | 242.3 ± 0.3% | 0.89 |
| canterbury/fields.c | 11150 | 283.6 ± 0.5% | 333.5 ± 1.1% | 338.2 ± 1.5% | 1.18 |
| canterbury/grammar.lsp | 3721 | 237.5 ± 0.2% | 250.7 ± 0.2% | 251.5 ± 0.2% | 1.06 |
| canterbury/kennedy.xls | 1029744 | 346.9 ± 0.4% | 432.9 ± 0.3% | 434.5 ± 0.1% | 1.25 |
| canterbury/lcet10.txt | 426754 | 222.8 ± 0.3% | 201.5 ± 0.3% | 201.6 ± 0.2% | 0.90 |
| canterbury/plrabn12.txt | 481861 | 188.2 ± 0.4% | 162.5 ± 0.5% | 162.5 ± 0.6% | 0.86 |
| canterbury/ptt5 | 513216 | 694.4 ± 0.5% | 510.9 ± 0.4% | 508.1 ± 1.0% | 0.74 |
| canterbury/sum | 38240 | 274.2 ± 0.7% | 219.6 ± 0.3% | 220.8 ± 0.7% | 0.80 |
| canterbury/xargs.1 | 4227 | 209.4 ± 0.2% | 230.7 ± 1.2% | 231.1 ± 0.8% | 1.10 |
| canterbury-large/E.coli | 4638690 | 261.8 ± 0.8% | 608.2 ± 0.5% | 610.8 ± 1.2% | 2.32 |
| canterbury-large/bible.txt | 4047392 | 243.6 ± 0.4% | 221.7 ± 0.3% | 221.9 ± 0.5% | 0.91 |
| canterbury-large/world192.txt | 2473400 | 262.1 ± 1.8% | 246.9 ± 2.0% | 246.0 ± 0.7% | 0.94 |
| http/html-1kx1024 | 1048576 | 105.3 ± 0.2% | 121.7 ± 0.1% | 122.2 ± 0.2% | 1.16 |
| http/html-16kx64 | 1048576 | 301.2 ± 0.2% | 295.1 ± 0.2% | 295.8 ± 0.2% | 0.98 |
| http/html-1m | 1048576 | 395.8 ± 0.4% | 351.0 ± 0.4% | 351.3 ± 0.3% | 0.89 |
| http/json-1kx1024 | 1048576 | 137.6 ± 0.3% | 157.1 ± 0.0% | 157.1 ± 0.1% | 1.14 |
| http/json-16kx64 | 1048576 | 447.6 ± 0.1% | 479.9 ± 0.1% | 479.2 ± 0.1% | 1.07 |
| http/json-1m | 1048576 | 554.3 ± 0.5% | 509.2 ± 0.3% | 507.0 ± 0.5% | 0.92 |
| http/js-1kx1024 | 1048576 | 97.4 ± 0.4% | 109.6 ± 0.2% | 110.0 ± 0.3% | 1.13 |
| http/js-16kx64 | 1048576 | 259.2 ± 0.2% | 253.5 ± 0.1% | 254.0 ± 0.2% | 0.98 |
| http/js-1m | 1048576 | 364.8 ± 0.4% | 334.4 ± 0.3% | 334.0 ± 0.3% | 0.92 |
| http/css-1kx1024 | 1048576 | 122.7 ± 0.2% | 139.9 ± 0.2% | 140.5 ± 0.2% | 1.14 |
| http/css-16kx64 | 1048576 | 380.3 ± 0.3% | 398.5 ± 0.2% | 400.3 ± 0.2% | 1.05 |
| http/css-1m | 1048576 | 581.5 ± 0.7% | 622.9 ± 0.3% | 620.7 ± 0.7% | 1.07 |
| shuffled/dickens-1m | 1048576 | 295.3 ± 0.4% | 643.9 ± 0.7% | 645.7 ± 0.5% | 2.18 |

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
| silesia/dickens | 10192446 | 29.8 ± 16.4% | 48.5 ± 0.5% | 1.63 |
| silesia/mozilla | 51220480 | 54.4 ± 4.4% | 58.3 ± 0.2% | 1.07 |
| silesia/mr | 9970564 | 41.7 ± 22.9% | 55.4 ± 0.9% | 1.33 |
| silesia/nci | 33553445 | 113.7 ± 0.4% | 129.3 ± 1.0% | 1.14 |
| silesia/ooffice | 6152192 | 38.3 ± 1.0% | 46.3 ± 0.7% | 1.21 |
| silesia/osdb | 10085684 | 50.5 ± 0.2% | 69.0 ± 0.7% | 1.37 |
| silesia/reymont | 6627202 | 43.3 ± 0.5% | 56.7 ± 1.4% | 1.31 |
| silesia/samba | 21606400 | 72.5 ± 18.2% | 82.7 ± 0.3% | 1.14 |
| silesia/sao | 7251944 | 30.6 ± 0.2% | 38.5 ± 0.7% | 1.26 |
| silesia/webster | 41458703 | 45.9 ± 1.9% | 61.1 ± 0.2% | 1.33 |
| silesia/x-ray | 8474240 | 33.0 ± 0.6% | 40.5 ± 0.7% | 1.23 |
| silesia/xml | 5345280 | 108.4 ± 0.4% | 130.7 ± 1.2% | 1.21 |
| canterbury/alice29.txt | 152089 | 43.2 ± 0.7% | 56.9 ± 0.6% | 1.32 |
| canterbury/asyoulik.txt | 125179 | 40.4 ± 0.4% | 51.1 ± 0.8% | 1.27 |
| canterbury/cp.html | 24603 | 55.9 ± 0.7% | 71.2 ± 0.5% | 1.27 |
| canterbury/fields.c | 11150 | 56.9 ± 1.4% | 84.0 ± 0.7% | 1.48 |
| canterbury/grammar.lsp | 3721 | 56.6 ± 0.7% | 86.5 ± 0.8% | 1.53 |
| canterbury/kennedy.xls | 1029744 | 72.6 ± 0.6% | 67.1 ± 0.4% | 0.92 |
| canterbury/lcet10.txt | 426754 | 44.4 ± 0.5% | 58.4 ± 0.9% | 1.32 |
| canterbury/plrabn12.txt | 481861 | 36.0 ± 0.2% | 46.6 ± 0.4% | 1.30 |
| canterbury/ptt5 | 513216 | 124.1 ± 0.6% | 120.7 ± 0.8% | 0.97 |
| canterbury/sum | 38240 | 51.9 ± 0.3% | 60.1 ± 0.4% | 1.16 |
| canterbury/xargs.1 | 4227 | 48.8 ± 0.7% | 76.2 ± 0.5% | 1.56 |
| canterbury-large/E.coli | 4638690 | 37.5 ± 0.5% | 109.8 ± 0.3% | 2.93 |
| canterbury-large/bible.txt | 4047392 | 42.8 ± 0.7% | 58.5 ± 0.9% | 1.37 |
| canterbury-large/world192.txt | 2473400 | 49.1 ± 0.4% | 71.8 ± 0.6% | 1.46 |
| http/html-1kx1024 | 1048576 | 31.9 ± 0.5% | 53.4 ± 0.8% | 1.67 |
| http/html-16kx64 | 1048576 | 72.3 ± 0.3% | 94.0 ± 0.4% | 1.30 |
| http/html-1m | 1048576 | 74.7 ± 0.3% | 100.0 ± 0.9% | 1.34 |
| http/json-1kx1024 | 1048576 | 42.9 ± 0.4% | 72.5 ± 0.4% | 1.69 |
| http/json-16kx64 | 1048576 | 94.8 ± 0.3% | 105.6 ± 0.9% | 1.11 |
| http/json-1m | 1048576 | 93.6 ± 0.7% | 97.0 ± 1.0% | 1.04 |
| http/js-1kx1024 | 1048576 | 29.1 ± 0.2% | 48.1 ± 0.3% | 1.65 |
| http/js-16kx64 | 1048576 | 60.9 ± 0.7% | 80.6 ± 0.8% | 1.32 |
| http/js-1m | 1048576 | 66.2 ± 1.0% | 92.3 ± 0.2% | 1.39 |
| http/css-1kx1024 | 1048576 | 39.3 ± 0.3% | 66.5 ± 0.5% | 1.69 |
| http/css-16kx64 | 1048576 | 90.6 ± 0.5% | 116.2 ± 0.7% | 1.28 |
| http/css-1m | 1048576 | 237.2 ± 0.8% | 286.7 ± 0.5% | 1.21 |
| shuffled/dickens-1m | 1048576 | 33.9 ± 0.8% | 81.2 ± 1.0% | 2.40 |

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
| silesia/dickens | 10192446 | 1 | 22 | 180.8 ± 0.4% | 2.522 |
| silesia/mozilla | 51220480 | 1 | 22 | 224.5 ± 0.5% | 2.516 |
| silesia/mr | 9970564 | 1 | 22 | 222.2 ± 0.3% | 2.658 |
| silesia/nci | 33553445 | 1 | 22 | 650.5 ± 0.5% | 9.472 |
| silesia/ooffice | 6152192 | 1 | 22 | 166.0 ± 0.4% | 1.770 |
| silesia/osdb | 10085684 | 1 | 22 | 235.6 ± 0.2% | 2.731 |
| silesia/reymont | 6627202 | 1 | 22 | 232.8 ± 0.8% | 3.052 |
| silesia/samba | 21606400 | 1 | 22 | 329.8 ± 0.2% | 3.880 |
| silesia/sao | 7251944 | 1 | 22 | 133.1 ± 0.6% | 1.226 |
| silesia/webster | 41458703 | 1 | 22 | 215.6 ± 0.7% | 3.080 |
| silesia/x-ray | 8474240 | 1 | 22 | 187.5 ± 0.6% | 1.267 |
| silesia/xml | 5345280 | 1 | 22 | 519.5 ± 0.5% | 6.994 |
| canterbury/alice29.txt | 152089 | 1 | 22 | 211.0 ± 0.7% | 2.523 |
| canterbury/asyoulik.txt | 125179 | 1 | 22 | 202.0 ± 0.4% | 2.344 |
| canterbury/cp.html | 24603 | 1 | 22 | 269.5 ± 1.9% | 2.682 |
| canterbury/fields.c | 11150 | 1 | 22 | 284.5 ± 0.3% | 2.965 |
| canterbury/grammar.lsp | 3721 | 1 | 22 | 237.2 ± 0.0% | 2.665 |
| canterbury/kennedy.xls | 1029744 | 1 | 22 | 340.5 ± 0.5% | 6.009 |
| canterbury/lcet10.txt | 426754 | 1 | 22 | 223.2 ± 0.5% | 2.755 |
| canterbury/plrabn12.txt | 481861 | 1 | 22 | 185.0 ± 0.4% | 2.338 |
| canterbury/ptt5 | 513216 | 1 | 22 | 696.8 ± 0.4% | 8.698 |
| canterbury/sum | 38240 | 1 | 22 | 277.9 ± 1.0% | 2.673 |
| canterbury/xargs.1 | 4227 | 1 | 22 | 208.5 ± 0.5% | 2.178 |
| canterbury-large/E.coli | 4638690 | 1 | 22 | 269.7 ± 0.1% | 3.283 |
| canterbury-large/bible.txt | 4047392 | 1 | 22 | 233.8 ± 0.1% | 3.128 |
| canterbury-large/world192.txt | 2473400 | 1 | 22 | 240.1 ± 0.4% | 3.264 |
| http/html-1kx1024 | 1048576 | 1 | 22 | 105.5 ± 0.2% | 2.436 |
| http/html-16kx64 | 1048576 | 1 | 22 | 302.1 ± 0.3% | 4.129 |
| http/html-1m | 1048576 | 1 | 22 | 391.0 ± 0.3% | 5.112 |
| http/json-1kx1024 | 1048576 | 1 | 22 | 137.6 ± 0.2% | 4.117 |
| http/json-16kx64 | 1048576 | 1 | 22 | 448.1 ± 0.2% | 6.727 |
| http/json-1m | 1048576 | 1 | 22 | 555.6 ± 0.2% | 7.629 |
| http/js-1kx1024 | 1048576 | 1 | 22 | 97.7 ± 0.3% | 2.143 |
| http/js-16kx64 | 1048576 | 1 | 22 | 260.0 ± 0.3% | 3.416 |
| http/js-1m | 1048576 | 1 | 22 | 363.0 ± 0.1% | 4.651 |
| http/css-1kx1024 | 1048576 | 1 | 22 | 122.9 ± 0.3% | 3.229 |
| http/css-16kx64 | 1048576 | 1 | 22 | 381.0 ± 0.1% | 5.368 |
| http/css-1m | 1048576 | 1 | 22 | 735.9 ± 0.3% | 9.626 |
| shuffled/dickens-1m | 1048576 | 1 | 22 | 291.7 ± 0.5% | 1.760 |

## stdx built ReleaseFast against Google's brotli, quality 11, window 22 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 435.4 ±1.1% | 556.1 ±2.1% | 1.28 |
| silesia/mozilla | 51220480 | 27.5 | 349.9 ±0.3% | 446.1 ±0.9% | 1.27 |
| silesia/mr | 9970564 | 28.3 | 312.1 ±2.0% | 415.3 ±1.3% | 1.33 |
| silesia/nci | 33553445 | 4.8 | 1581.1 ±0.4% | 1847.0 ±2.5% | 1.17 |
| silesia/ooffice | 6152192 | 40.3 | 237.1 ±1.4% | 291.7 ±2.1% | 1.23 |
| silesia/osdb | 10085684 | 28.0 | 376.5 ±0.2% | 528.9 ±2.4% | 1.40 |
| silesia/reymont | 6627202 | 20.2 | 597.1 ±0.4% | 800.7 ±1.0% | 1.34 |
| silesia/samba | 21606400 | 17.7 | 628.8 ±0.5% | 852.9 ±0.7% | 1.36 |
| silesia/sao | 7251944 | 63.3 | 184.2 ±1.4% | 276.7 ±2.3% | 1.50 |
| silesia/webster | 41458703 | 21.2 | 535.7 ±0.8% | 656.1 ±2.3% | 1.22 |
| silesia/x-ray | 8474240 | 55.3 | 161.3 ±1.1% | 195.6 ±1.1% | 1.21 |
| silesia/xml | 5345280 | 8.1 | 1306.8 ±0.6% | 1894.6 ±0.5% | 1.45 |
| canterbury/alice29.txt | 152089 | 30.6 | 383.9 ±0.1% | 572.4 ±0.9% | 1.49 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 327.1 ±0.2% | 492.0 ±0.7% | 1.50 |
| canterbury/cp.html | 24603 | 28.0 | 377.2 ±0.8% | 614.1 ±2.6% | 1.63 |
| canterbury/fields.c | 11150 | 24.4 | 491.8 ±1.1% | 725.8 ±0.2% | 1.48 |
| canterbury/grammar.lsp | 3721 | 30.2 | 348.3 ±0.2% | 502.5 ±0.3% | 1.44 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 619.7 ±0.3% | 901.8 ±0.4% | 1.46 |
| canterbury/lcet10.txt | 426754 | 26.6 | 440.5 ±0.4% | 660.7 ±0.2% | 1.50 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 375.2 ±0.2% | 549.3 ±0.3% | 1.46 |
| canterbury/ptt5 | 513216 | 8.0 | 795.9 ±0.1% | 1449.6 ±0.2% | 1.82 |
| canterbury/sum | 38240 | 26.5 | 314.6 ±0.3% | 424.1 ±1.4% | 1.35 |
| canterbury/xargs.1 | 4227 | 34.6 | 312.1 ±0.3% | 425.5 ±0.2% | 1.36 |
| canterbury-large/E.coli | 4638690 | 24.5 | 400.9 ±0.2% | 494.1 ±0.4% | 1.23 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 598.9 ±1.3% | 838.7 ±0.4% | 1.40 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 581.2 ±0.6% | 782.2 ±0.3% | 1.35 |
| http/html-1kx1024 | 1048576 | 30.3 | 189.7 ±0.2% | 235.9 ±0.2% | 1.24 |
| http/html-16kx64 | 1048576 | 16.8 | 505.4 ±0.1% | 686.3 ±0.1% | 1.36 |
| http/html-1m | 1048576 | 13.0 | 845.6 ±0.5% | 1200.3 ±0.3% | 1.42 |
| http/json-1kx1024 | 1048576 | 18.2 | 236.3 ±0.1% | 281.8 ±0.2% | 1.19 |
| http/json-16kx64 | 1048576 | 8.9 | 771.5 ±0.1% | 1039.1 ±0.2% | 1.35 |
| http/json-1m | 1048576 | 7.7 | 997.6 ±0.3% | 1390.9 ±0.2% | 1.39 |
| http/js-1kx1024 | 1048576 | 35.1 | 171.7 ±0.5% | 219.4 ±0.1% | 1.28 |
| http/js-16kx64 | 1048576 | 20.7 | 424.0 ±0.1% | 583.2 ±0.2% | 1.38 |
| http/js-1m | 1048576 | 14.0 | 786.1 ±0.3% | 1071.3 ±0.2% | 1.36 |
| http/css-1kx1024 | 1048576 | 22.5 | 220.8 ±0.1% | 262.8 ±0.1% | 1.19 |
| http/css-16kx64 | 1048576 | 11.7 | 689.1 ±0.1% | 923.5 ±0.2% | 1.34 |
| http/css-1m | 1048576 | 2.4 | 1396.1 ±0.7% | 4734.9 ±0.3% | 3.39 |
| shuffled/dickens-1m | 1048576 | 56.8 | 331.1 ±0.2% | 385.1 ±0.6% | 1.16 |
