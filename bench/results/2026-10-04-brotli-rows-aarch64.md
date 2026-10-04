# bench-brotli

| Field | Value |
|---|---|
| Commit | 62875f6 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37230103795 |
| Date | 2026-10-04 |

## Decoding, quality 11, window 22

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 419.6 ±1.5% | 549.2 ±1.8% | 1.31 |
| silesia/mozilla | 51220480 | 27.5 | 344.7 ±0.6% | 441.9 ±1.0% | 1.28 |
| silesia/mr | 9970564 | 28.3 | 304.9 ±0.7% | 411.3 ±2.9% | 1.35 |
| silesia/nci | 33553445 | 4.8 | 1558.2 ±0.6% | 1873.4 ±3.1% | 1.20 |
| silesia/ooffice | 6152192 | 40.3 | 234.2 ±1.4% | 289.2 ±0.7% | 1.24 |
| silesia/osdb | 10085684 | 28.0 | 369.6 ±0.9% | 532.4 ±2.7% | 1.44 |
| silesia/reymont | 6627202 | 20.2 | 571.3 ±11.9% | 773.2 ±28.2% | 1.35 |
| silesia/samba | 21606400 | 17.7 | 616.4 ±0.7% | 839.2 ±1.5% | 1.36 |
| silesia/sao | 7251944 | 63.3 | 186.2 ±1.5% | 276.1 ±2.5% | 1.48 |
| silesia/webster | 41458703 | 21.2 | 519.7 ±0.9% | 655.4 ±1.4% | 1.26 |
| silesia/x-ray | 8474240 | 55.3 | 154.4 ±3.0% | 189.6 ±0.8% | 1.23 |
| silesia/xml | 5345280 | 8.1 | 1283.7 ±0.7% | 1860.6 ±0.1% | 1.45 |
| canterbury/alice29.txt | 152089 | 30.6 | 380.7 ±0.1% | 554.5 ±1.0% | 1.46 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 324.6 ±0.1% | 477.0 ±1.1% | 1.47 |
| canterbury/cp.html | 24603 | 28.0 | 372.1 ±0.4% | 583.1 ±3.3% | 1.57 |
| canterbury/fields.c | 11150 | 24.4 | 482.9 ±1.3% | 691.8 ±0.3% | 1.43 |
| canterbury/grammar.lsp | 3721 | 30.2 | 345.1 ±0.3% | 464.1 ±0.0% | 1.34 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 606.5 ±0.3% | 880.8 ±0.4% | 1.45 |
| canterbury/lcet10.txt | 426754 | 26.6 | 433.4 ±0.2% | 645.5 ±0.3% | 1.49 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 367.8 ±0.2% | 545.3 ±0.2% | 1.48 |
| canterbury/ptt5 | 513216 | 8.0 | 792.4 ±0.1% | 1411.1 ±0.1% | 1.78 |
| canterbury/sum | 38240 | 26.5 | 312.8 ±0.7% | 412.9 ±0.7% | 1.32 |
| canterbury/xargs.1 | 4227 | 34.6 | 311.9 ±0.4% | 394.0 ±0.2% | 1.26 |
| canterbury-large/E.coli | 4638690 | 24.5 | 433.3 ±0.3% | 494.4 ±0.1% | 1.14 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 581.6 ±0.5% | 828.6 ±0.4% | 1.42 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 567.2 ±0.3% | 768.4 ±0.2% | 1.35 |
| http/html-1kx1024 | 1048576 | 30.3 | 189.0 ±0.0% | 219.1 ±0.1% | 1.16 |
| http/html-16kx64 | 1048576 | 16.8 | 501.4 ±0.1% | 653.9 ±0.1% | 1.30 |
| http/html-1m | 1048576 | 13.0 | 827.2 ±0.6% | 1171.3 ±0.4% | 1.42 |
| http/json-1kx1024 | 1048576 | 18.2 | 237.0 ±0.0% | 256.6 ±0.1% | 1.08 |
| http/json-16kx64 | 1048576 | 8.9 | 767.6 ±0.1% | 994.1 ±0.1% | 1.30 |
| http/json-1m | 1048576 | 7.7 | 984.0 ±0.2% | 1357.8 ±0.4% | 1.38 |
| http/js-1kx1024 | 1048576 | 35.1 | 170.9 ±0.0% | 204.7 ±0.1% | 1.20 |
| http/js-16kx64 | 1048576 | 20.7 | 421.5 ±0.1% | 557.4 ±0.1% | 1.32 |
| http/js-1m | 1048576 | 14.0 | 769.6 ±0.4% | 1057.6 ±0.5% | 1.37 |
| http/css-1kx1024 | 1048576 | 22.5 | 220.8 ±0.1% | 242.2 ±0.2% | 1.10 |
| http/css-16kx64 | 1048576 | 11.7 | 686.2 ±0.0% | 878.9 ±0.2% | 1.28 |
| http/css-1m | 1048576 | 2.4 | 1391.8 ±0.3% | 4603.3 ±0.5% | 3.31 |
| shuffled/dickens-1m | 1048576 | 56.8 | 349.1 ±0.7% | 386.6 ±0.4% | 1.11 |

## stdx's fast path against its checked path

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 108.3 ±2.5% | 551.2 ±2.7% | 5.09 |
| silesia/mozilla | 51220480 | 27.5 | 109.2 ±0.7% | 442.9 ±1.3% | 4.06 |
| silesia/mr | 9970564 | 28.3 | 105.3 ±1.4% | 410.2 ±1.0% | 3.89 |
| silesia/nci | 33553445 | 4.8 | 210.3 ±0.5% | 1860.8 ±2.3% | 8.85 |
| silesia/ooffice | 6152192 | 40.3 | 81.5 ±0.4% | 292.9 ±1.4% | 3.59 |
| silesia/osdb | 10085684 | 28.0 | 117.2 ±1.4% | 526.5 ±3.3% | 4.49 |
| silesia/reymont | 6627202 | 20.2 | 131.0 ±1.5% | 784.8 ±1.2% | 5.99 |
| silesia/samba | 21606400 | 17.7 | 151.3 ±0.3% | 847.3 ±1.4% | 5.60 |
| silesia/sao | 7251944 | 63.3 | 78.1 ±0.9% | 278.7 ±1.6% | 3.57 |
| silesia/webster | 41458703 | 21.2 | 123.4 ±1.2% | 649.3 ±1.9% | 5.26 |
| silesia/x-ray | 8474240 | 55.3 | 66.2 ±1.1% | 190.9 ±1.5% | 2.88 |
| silesia/xml | 5345280 | 8.1 | 198.0 ±0.3% | 1869.6 ±0.5% | 9.44 |
| canterbury/alice29.txt | 152089 | 30.6 | 108.5 ±0.1% | 556.2 ±0.4% | 5.13 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 100.4 ±0.1% | 477.2 ±1.1% | 4.75 |
| canterbury/cp.html | 24603 | 28.0 | 112.9 ±0.1% | 602.5 ±2.2% | 5.34 |
| canterbury/fields.c | 11150 | 24.4 | 115.7 ±0.2% | 688.5 ±0.4% | 5.95 |
| canterbury/grammar.lsp | 3721 | 30.2 | 99.8 ±0.2% | 463.4 ±0.1% | 4.64 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 129.2 ±0.2% | 876.0 ±0.2% | 6.78 |
| canterbury/lcet10.txt | 426754 | 26.6 | 119.4 ±0.2% | 648.7 ±0.5% | 5.43 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 106.7 ±0.1% | 546.9 ±0.3% | 5.13 |
| canterbury/ptt5 | 513216 | 8.0 | 185.4 ±0.1% | 1426.8 ±0.4% | 7.70 |
| canterbury/sum | 38240 | 26.5 | 97.0 ±0.1% | 418.7 ±1.5% | 4.32 |
| canterbury/xargs.1 | 4227 | 34.6 | 91.1 ±0.3% | 391.5 ±0.2% | 4.30 |
| canterbury-large/E.coli | 4638690 | 24.5 | 108.5 ±0.1% | 494.7 ±0.4% | 4.56 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 131.9 ±2.0% | 836.4 ±0.8% | 6.34 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 141.5 ±0.6% | 772.2 ±0.4% | 5.46 |
| http/html-1kx1024 | 1048576 | 30.3 | 84.8 ±0.3% | 220.0 ±0.2% | 2.59 |
| http/html-16kx64 | 1048576 | 16.8 | 137.9 ±0.1% | 653.5 ±0.2% | 4.74 |
| http/html-1m | 1048576 | 13.0 | 165.2 ±0.1% | 1176.2 ±0.3% | 7.12 |
| http/json-1kx1024 | 1048576 | 18.2 | 98.9 ±0.1% | 257.2 ±0.1% | 2.60 |
| http/json-16kx64 | 1048576 | 8.9 | 162.7 ±0.0% | 993.2 ±0.1% | 6.10 |
| http/json-1m | 1048576 | 7.7 | 172.8 ±0.1% | 1359.6 ±0.1% | 7.87 |
| http/js-1kx1024 | 1048576 | 35.1 | 78.3 ±0.3% | 205.2 ±0.0% | 2.62 |
| http/js-16kx64 | 1048576 | 20.7 | 125.1 ±0.0% | 553.9 ±0.2% | 4.43 |
| http/js-1m | 1048576 | 14.0 | 159.2 ±0.5% | 1062.6 ±0.6% | 6.68 |
| http/css-1kx1024 | 1048576 | 22.5 | 93.6 ±0.2% | 242.7 ±0.2% | 2.59 |
| http/css-16kx64 | 1048576 | 11.7 | 155.5 ±0.1% | 874.3 ±0.1% | 5.62 |
| http/css-1m | 1048576 | 2.4 | 247.8 ±0.6% | 4552.7 ±1.6% | 18.37 |
| shuffled/dickens-1m | 1048576 | 56.8 | 93.5 ±0.2% | 387.1 ±0.3% | 4.14 |

## The claims, each off against the fast path with all on

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | S1 word refill off | S4 chunk copies off | S5 window once off | unchecked loop off |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 545.2 ±2.0% | 0.54 ±2.2% | 0.52 ±5.9% | 0.97 ±3.9% | 0.52 ±5.5% |
| silesia/mozilla | 51220480 | 27.5 | 443.5 ±1.6% | 0.67 ±1.1% | 0.65 ±1.1% | 0.98 ±0.5% | 0.66 ±0.8% |
| silesia/mr | 9970564 | 28.3 | 408.8 ±2.8% | 0.65 ±2.5% | 0.63 ±3.4% | 1.00 ±2.0% | 0.63 ±2.9% |
| silesia/nci | 33553445 | 4.8 | 1835.2 ±2.4% | 0.66 ±1.7% | 0.51 ±1.1% | 0.93 ±1.9% | 0.62 ±0.8% |
| silesia/ooffice | 6152192 | 40.3 | 287.6 ±1.2% | 0.67 ±1.6% | 0.66 ±1.4% | 0.99 ±2.1% | 0.65 ±2.9% |
| silesia/osdb | 10085684 | 28.0 | 540.0 ±1.7% | 0.64 ±4.3% | 0.60 ±2.9% | 0.96 ±3.5% | 0.64 ±3.6% |
| silesia/reymont | 6627202 | 20.2 | 788.8 ±1.1% | 0.55 ±0.5% | 0.49 ±3.0% | 0.97 ±1.3% | 0.52 ±5.9% |
| silesia/samba | 21606400 | 17.7 | 846.5 ±0.9% | 0.64 ±0.8% | 0.59 ±1.2% | 0.96 ±0.9% | 0.63 ±0.8% |
| silesia/sao | 7251944 | 63.3 | 277.4 ±2.9% | 0.67 ±1.4% | 0.72 ±1.5% | 1.01 ±2.4% | 0.67 ±1.9% |
| silesia/webster | 41458703 | 21.2 | 664.4 ±1.6% | 0.55 ±5.9% | 0.52 ±4.0% | 0.96 ±2.8% | 0.54 ±5.6% |
| silesia/x-ray | 8474240 | 55.3 | 190.4 ±1.7% | 0.72 ±2.1% | 0.81 ±2.7% | 1.00 ±0.9% | 0.70 ±3.8% |
| silesia/xml | 5345280 | 8.1 | 1876.0 ±0.4% | 0.60 ±0.5% | 0.47 ±0.6% | 0.94 ±0.3% | 0.57 ±0.4% |
| canterbury/alice29.txt | 152089 | 30.6 | 562.3 ±1.0% | 0.59 ±0.2% | 0.55 ±0.2% | 0.98 ±0.4% | 0.58 ±0.1% |
| canterbury/asyoulik.txt | 125179 | 34.1 | 480.5 ±0.8% | 0.60 ±0.1% | 0.57 ±0.1% | 0.98 ±0.4% | 0.58 ±0.2% |
| canterbury/cp.html | 24603 | 28.0 | 601.1 ±0.9% | 0.59 ±0.3% | 0.57 ±0.8% | 0.98 ±4.3% | 0.55 ±0.3% |
| canterbury/fields.c | 11150 | 24.4 | 691.2 ±0.2% | 0.60 ±0.8% | 0.57 ±1.5% | 0.97 ±0.4% | 0.50 ±0.4% |
| canterbury/grammar.lsp | 3721 | 30.2 | 462.6 ±0.2% | 0.70 ±0.4% | 0.71 ±0.9% | 0.99 ±0.2% | 0.61 ±0.5% |
| canterbury/kennedy.xls | 1029744 | 6.0 | 862.9 ±0.4% | 0.60 ±0.3% | 0.54 ±0.2% | 0.97 ±0.3% | 0.51 ±0.3% |
| canterbury/lcet10.txt | 426754 | 26.6 | 650.9 ±0.2% | 0.60 ±0.2% | 0.55 ±0.3% | 0.97 ±0.2% | 0.59 ±0.1% |
| canterbury/plrabn12.txt | 481861 | 33.9 | 550.2 ±0.3% | 0.58 ±0.1% | 0.54 ±0.3% | 0.97 ±0.5% | 0.56 ±0.2% |
| canterbury/ptt5 | 513216 | 8.0 | 1423.3 ±0.1% | 0.69 ±0.1% | 0.48 ±0.4% | 0.96 ±0.5% | 0.67 ±0.1% |
| canterbury/sum | 38240 | 26.5 | 418.6 ±2.8% | 0.66 ±0.7% | 0.64 ±0.4% | 0.98 ±2.7% | 0.63 ±0.3% |
| canterbury/xargs.1 | 4227 | 34.6 | 393.4 ±0.5% | 0.72 ±0.5% | 0.71 ±1.3% | 0.98 ±0.6% | 0.61 ±0.6% |
| canterbury-large/E.coli | 4638690 | 24.5 | 494.7 ±0.2% | 0.88 ±1.2% | 0.91 ±0.4% | 0.98 ±0.5% | 0.88 ±0.6% |
| canterbury-large/bible.txt | 4047392 | 22.0 | 840.3 ±0.5% | 0.54 ±1.0% | 0.49 ±1.1% | 0.96 ±0.6% | 0.53 ±0.6% |
| canterbury-large/world192.txt | 2473400 | 19.2 | 777.1 ±0.5% | 0.62 ±0.7% | 0.56 ±0.4% | 0.96 ±0.2% | 0.60 ±0.6% |
| http/html-1kx1024 | 1048576 | 30.3 | 220.1 ±0.1% | 0.80 ±0.2% | 0.81 ±0.1% | 0.98 ±0.1% | 0.80 ±0.1% |
| http/html-16kx64 | 1048576 | 16.8 | 654.7 ±0.2% | 0.69 ±0.0% | 0.63 ±0.1% | 0.98 ±0.3% | 0.65 ±0.1% |
| http/html-1m | 1048576 | 13.0 | 1178.7 ±0.2% | 0.59 ±0.3% | 0.51 ±0.2% | 0.95 ±0.4% | 0.57 ±0.3% |
| http/json-1kx1024 | 1048576 | 18.2 | 257.4 ±0.1% | 0.85 ±0.1% | 0.84 ±0.1% | 0.97 ±0.0% | 0.83 ±0.1% |
| http/json-16kx64 | 1048576 | 8.9 | 1000.1 ±0.1% | 0.66 ±0.2% | 0.59 ±0.1% | 0.96 ±0.1% | 0.62 ±0.2% |
| http/json-1m | 1048576 | 7.7 | 1371.1 ±0.4% | 0.61 ±0.2% | 0.52 ±0.4% | 0.94 ±0.5% | 0.56 ±0.4% |
| http/js-1kx1024 | 1048576 | 35.1 | 204.9 ±0.2% | 0.79 ±0.2% | 0.79 ±0.1% | 0.98 ±0.2% | 0.78 ±0.1% |
| http/js-16kx64 | 1048576 | 20.7 | 557.0 ±0.4% | 0.68 ±0.2% | 0.63 ±0.1% | 0.98 ±0.1% | 0.64 ±0.1% |
| http/js-1m | 1048576 | 14.0 | 1068.5 ±0.2% | 0.59 ±0.3% | 0.51 ±0.1% | 0.95 ±0.5% | 0.58 ±0.3% |
| http/css-1kx1024 | 1048576 | 22.5 | 244.0 ±0.2% | 0.82 ±0.2% | 0.81 ±0.1% | 0.97 ±0.1% | 0.82 ±0.2% |
| http/css-16kx64 | 1048576 | 11.7 | 881.8 ±0.2% | 0.66 ±0.2% | 0.57 ±0.1% | 0.97 ±0.1% | 0.63 ±0.4% |
| http/css-1m | 1048576 | 2.4 | 4695.2 ±0.5% | 0.63 ±0.2% | 0.35 ±0.2% | 0.85 ±1.0% | 0.57 ±0.4% |
| shuffled/dickens-1m | 1048576 | 56.8 | 386.3 ±0.3% | 0.87 ±0.5% | 0.94 ±0.1% | 0.99 ±0.2% | 0.92 ±0.2% |

## stdx built ReleaseFast against Google's brotli, quality 11, window 22 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 418.8 ±0.7% | 563.1 ±2.5% | 1.34 |
| silesia/mozilla | 51220480 | 27.5 | 346.5 ±0.5% | 452.2 ±0.7% | 1.31 |
| silesia/mr | 9970564 | 28.3 | 303.8 ±1.1% | 420.8 ±1.8% | 1.39 |
| silesia/nci | 33553445 | 4.8 | 1564.3 ±0.8% | 1893.1 ±1.4% | 1.21 |
| silesia/ooffice | 6152192 | 40.3 | 236.0 ±0.5% | 294.4 ±0.7% | 1.25 |
| silesia/osdb | 10085684 | 28.0 | 372.1 ±0.6% | 548.1 ±2.3% | 1.47 |
| silesia/reymont | 6627202 | 20.2 | 579.3 ±0.6% | 786.8 ±0.9% | 1.36 |
| silesia/samba | 21606400 | 17.7 | 620.6 ±0.6% | 864.6 ±1.2% | 1.39 |
| silesia/sao | 7251944 | 63.3 | 187.9 ±0.5% | 286.5 ±1.1% | 1.52 |
| silesia/webster | 41458703 | 21.2 | 520.3 ±0.5% | 676.6 ±1.9% | 1.30 |
| silesia/x-ray | 8474240 | 55.3 | 155.8 ±1.1% | 197.3 ±1.0% | 1.27 |
| silesia/xml | 5345280 | 8.1 | 1287.7 ±0.5% | 1904.1 ±0.2% | 1.48 |
| canterbury/alice29.txt | 152089 | 30.6 | 381.0 ±0.1% | 573.9 ±1.1% | 1.51 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 325.0 ±0.1% | 491.7 ±1.2% | 1.51 |
| canterbury/cp.html | 24603 | 28.0 | 370.3 ±0.8% | 618.6 ±2.6% | 1.67 |
| canterbury/fields.c | 11150 | 24.4 | 485.4 ±1.4% | 730.5 ±0.3% | 1.50 |
| canterbury/grammar.lsp | 3721 | 30.2 | 344.8 ±0.1% | 500.9 ±0.1% | 1.45 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 604.7 ±0.3% | 909.4 ±0.3% | 1.50 |
| canterbury/lcet10.txt | 426754 | 26.6 | 435.1 ±0.2% | 670.9 ±0.2% | 1.54 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 369.3 ±0.2% | 557.0 ±0.4% | 1.51 |
| canterbury/ptt5 | 513216 | 8.0 | 788.5 ±0.2% | 1440.0 ±0.4% | 1.83 |
| canterbury/sum | 38240 | 26.5 | 311.7 ±0.4% | 425.6 ±1.2% | 1.37 |
| canterbury/xargs.1 | 4227 | 34.6 | 312.2 ±0.9% | 428.8 ±0.3% | 1.37 |
| canterbury-large/E.coli | 4638690 | 24.5 | 439.3 ±0.2% | 494.9 ±0.2% | 1.13 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 580.9 ±0.9% | 833.8 ±0.8% | 1.44 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 565.9 ±0.4% | 780.6 ±0.4% | 1.38 |
| http/html-1kx1024 | 1048576 | 30.3 | 188.8 ±0.1% | 236.2 ±0.1% | 1.25 |
| http/html-16kx64 | 1048576 | 16.8 | 501.6 ±0.1% | 687.5 ±0.2% | 1.37 |
| http/html-1m | 1048576 | 13.0 | 829.3 ±0.3% | 1200.5 ±0.3% | 1.45 |
| http/json-1kx1024 | 1048576 | 18.2 | 237.5 ±0.1% | 281.4 ±0.1% | 1.18 |
| http/json-16kx64 | 1048576 | 8.9 | 766.4 ±0.1% | 1025.8 ±0.2% | 1.34 |
| http/json-1m | 1048576 | 7.7 | 984.8 ±0.3% | 1394.8 ±0.3% | 1.42 |
| http/js-1kx1024 | 1048576 | 35.1 | 170.8 ±0.1% | 219.6 ±0.0% | 1.29 |
| http/js-16kx64 | 1048576 | 20.7 | 421.4 ±0.1% | 582.5 ±0.3% | 1.38 |
| http/js-1m | 1048576 | 14.0 | 770.9 ±0.2% | 1085.4 ±0.3% | 1.41 |
| http/css-1kx1024 | 1048576 | 22.5 | 221.0 ±0.1% | 263.5 ±0.1% | 1.19 |
| http/css-16kx64 | 1048576 | 11.7 | 684.5 ±0.0% | 923.2 ±0.2% | 1.35 |
| http/css-1m | 1048576 | 2.4 | 1389.0 ±0.3% | 4742.0 ±0.4% | 3.41 |
| shuffled/dickens-1m | 1048576 | 56.8 | 349.6 ±0.5% | 387.5 ±0.4% | 1.11 |
